Return-Path: <linux-kernel-owner+w=401wt.eu-S1760492AbZFQVby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760492AbZFQVby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 17:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905AbZFQVbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 17:31:47 -0400
Received: from fifo99.com ([67.223.236.141]:42684 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbZFQVbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 17:31:47 -0400
Subject: Re: [PATCH 1/6] staging: android: binder: Remove some funny &&
	usage
From: Daniel Walker <dwalker@fifo99.com>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Greg Kroah-Hartman <greg@kroah.com>,
       Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org
In-Reply-To: <d6200be20906171426n71979124i4b359b6f4fc35d7e@mail.gmail.com>
References: <1244832678-30329-1-git-send-email-dwalker@fifo99.com>
	 <4A380494.6030506@goop.org> <1245249469.5982.251.camel@desktop>
	 <4A390B9A.40806@goop.org> <1245254936.5982.261.camel@desktop>
	 <4A391A54.7000109@goop.org>
	 <d6200be20906171426n71979124i4b359b6f4fc35d7e@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Wed, 17 Jun 2009 14:31:48 -0700
Message-Id: <1245274308.5982.268.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-17 at 14:26 -0700, Arve Hjønnevåg wrote:
> On Wed, Jun 17, 2009 at 9:31 AM, Jeremy Fitzhardinge<jeremy@goop.org> wrote:
> > On 06/17/09 09:08, Daniel Walker wrote:
> ...
> > Also, what its usermode ABI is, how stable it is, whether its generally
> > useful, does it have glibc/other library support, etc.  Would you ever want
> > to use this in a non-Android context?
> 
> You could use this in a non-android context, but the abi is not
> stable. There is some documentaion of the current user space api at
> http://developer.android.com/reference/android/os/IBinder.html. You
> can also find more information at http://www.open-binder.org/ which is
> where the api came from.


Why does all this need to be done in the kernel? Couldn't any of the
current IPC mechanisms be re-used to accomplish this?

Daniel

