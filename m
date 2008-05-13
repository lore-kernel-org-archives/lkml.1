Return-Path: <linux-kernel-owner+w=401wt.eu-S1761135AbYEMRT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761135AbYEMRT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 13:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757261AbYEMRTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 13:19:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38262 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873AbYEMRTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 13:19:15 -0400
Message-ID: <4829CB8B.1000500@zytor.com>
Date: Tue, 13 May 2008 10:10:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: David Chinner <dgc@sgi.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       util-linux-ng@vger.kernel.org
Subject: Re: [BUG] remount ro on loopback mount leaves unmountable	filesystem
 behind
References: <20080513085047.GY155679365@sgi.com> <20080513102340.GA15112@infradead.org> <20080513120710.GA155679365@sgi.com> <20080513124203.GA4806@infradead.org>
In-Reply-To: <20080513124203.GA4806@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Tue, May 13, 2008 at 10:07:10PM +1000, David Chinner wrote:
>> Anyway, I'll hard code loop device numbers into the script so
>> I can just forget about this problem. Thanks, Christoph.
> 
> hardcoding them is a little dangerous because a system might aswell
> have them in use already, e.g. for CD images.  Just use losetup -f to
> find the first free one and keep it in a shell variable.

losetup -f is racy, too.  losetup -sf is safe, however.

	-hpa
