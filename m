Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbYC1LFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbYC1LFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 07:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbYC1LE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 07:04:57 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:64778 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395AbYC1LE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 07:04:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=aOCBV1XyHRHEDXqY1FL5biId0C9iuzcFB1kvAzamGTyKHfYchW0tsfdVkennbS/JvVkj1dpQPvopyxvOL6vosiI8GXp4JzNOZILWm0Qj0nTIHA1+b/f+UGhMiIW7vch3WRKkuNZQ3bSTE8CqOQZgKA0nuyvol2J+mGp8S2yUWx8=
Message-ID: <47ECD0CF.1020003@gmail.com>
Date: Fri, 28 Mar 2008 12:04:47 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linux and Kernel Video <video4linux-list@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: v4l & compat_ioctl
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

wouldn't make sense to add v4l ioctls to ioctl_start (fs/compat_ioctl.c) table 
to allow i386 stuff such as skype to run video on x86_64? The ioctl structures 
seem to be pretty aliasable, so even no special handler wouldn't be neded...

Otherwise people are getting crap like this:
ioctl32(skype:29183): Unknown cmd fd(13) cmd(80685600){t:'V';sz:104} 
arg(f6571054) on /dev/video0
