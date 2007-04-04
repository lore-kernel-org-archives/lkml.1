Return-Path: <linux-kernel-owner+w=401wt.eu-S966303AbXDDFjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966303AbXDDFjd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 01:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966307AbXDDFjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 01:39:33 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:24723 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966303AbXDDFjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 01:39:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Jc6n8Ewf6TSwwzmurDQxJg/ZmU+zb1W1b1wamhoygxfV7lTsqOzO1NrY9MA6YL4dBDBLr/hBet6Im14hK4O3/hXn9O4SYzXlStW3jyOYIH97btYoFswrB6m/xUF/zgKgOtsBDGMA7zTXRquJdk1Tdrn7kd0O8aigyVEVUt5V+Cc=
Subject: Re: [PATCH] vt: Expose system-wide UTF-8 default setting via sysfs
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Paul LeoNerd Evans <leonerd@leonerd.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20070403163553.GO26707@cel.leo>
References: <4611ACCD.5000305@gmail.com> <20070403162051.GB5266@ucw.cz>
	 <20070403163553.GO26707@cel.leo>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 13:39:23 +0800
Message-Id: <1175665163.4519.7.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-03 at 17:35 +0100, Paul LeoNerd Evans wrote:
> On Tue, Apr 03, 2007 at 04:20:52PM +0000, Pavel Machek wrote:
> > HPA is right... this should be fixed in userland. Reset should reset a
> > console, and if you want utf-8, do \ec\ewhatever to get it.
> 
> As I've already said elsewhere, does anything say that "reset" means
> that UTF-8 is turned off, or merely reset back to some known state? I
> personally would consider that UTF-8 being on is the default, and if
> something wants it off it should ask specifically..
> 
> Consider any other terminal emulator, such as those running on X11; when
> they're reset, they know to keep UTF-8 mode turned on, because it said
> so in their config, or in the locale. Kernel doesn't really have nice
> access to the LANG environment variable, but we can give it something
> similar; namely, via a module parameter.

I agree with Paul.  Reset or RIS is (R)eset to (I)nitial (S)tate,
represented as ESC 06/03. "Initial state" is defined in ECMA-48 as the
state of the device after it was made operational. It doesn't
necessarily mean that the "initial state" is the safest configuration.
So, if this "initial state" includes enabling UTF-8, then the device has
to go into UTF-8 upon invoking RIS.

Tony

