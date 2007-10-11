Return-Path: <linux-kernel-owner+w=401wt.eu-S1756123AbXJKJrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbXJKJrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 05:47:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbXJKJq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 05:46:58 -0400
Received: from smtpoutm.mac.com ([17.148.16.83]:59539 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781AbXJKJq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 05:46:58 -0400
In-Reply-To: <200710111035.38644.philipp.marek@bmlv.gv.at>
References: <200710111035.38644.philipp.marek@bmlv.gv.at>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <0B7254BB-130C-4175-BF26-0BF0D96524C5@mac.com>
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: "mount --bind" with user/group/mode definition?
Date: Thu, 11 Oct 2007 05:46:38 -0400
To: "Ph. Marek" <philipp.marek@bmlv.gv.at>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 11, 2007, at 04:35:37, Ph. Marek wrote:
> is there some way to duplicate a directory somewhere else (like  
> with "mount --bind"), but having different owner/group/mode bits?
>
> I'd like to mount a directory I have no control over (think NFS, or  
> floppy, ...) with clearly defined rights - like root:<some group>,  
> mode 0550 for all directories, and 0440 for all files. (Here I want  
> to have full *read* control, regardless of the original permissions).
> [ I know that this special case can be (mostly) done by a read-only  
> binding mount; the part that is missing is eg. files with a  
> different owner being 0700. ]
>
> I know that something like this is possible for eg. VFAT, which has  
> no right descriptors for itself; but I'd need that for arbitrary  
> directory trees, who  themselves *have* permissions set.
>
> Is there some way to achieve that?

Not at the moment, unfortunately.  I suspect that with the recent  
developments in user container support and/or overlay mounting it  
will become possible to either write a UID/GID-translation overlay  
filesystem or grant cross-UID-container keys to achieve what you  
want.  On the other hand that probably won't fully happen for up to a  
year or so.

Cheers,
Kyle Moffett
