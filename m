Return-Path: <linux-kernel-owner+w=401wt.eu-S1753249AbZGBFhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbZGBFhc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 01:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbZGBFhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 01:37:25 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:61311 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbZGBFhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 01:37:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=bfwdjR0Ob31ssR/tv8okYEdXkoazEN8zG0KA7BSPtlx93cIVW1WwmGlUkhFgXT/jQb
         S9MVe+mgPnL9p59auFp3lGhGfAc3/4cfE1Py4fpofLH8PKUIlrqRhACj3lkdxLsFy4hK
         /5zSgmb8oTmwpzA8dTysSLe3fQpI4/9vwt7zU=
Message-ID: <4A4C47DC.90005@gmail.com>
Date: Wed, 01 Jul 2009 22:38:36 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009031304)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [patch0/8] SELinux non trivial fixes.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hmm man!! I used  -compose
on the git interface and sent them to myself numerous
times to make sure it works..(I don't know why git didn't send 0/8)

Here's the compose part if it never was sent for some reason:

I decided to sit and manually write out all of the SELinux
area(or at least some of it). So along the way
whenever I saw what might need a bit of cleaning up
I wrote it down, and then once finished
created a patch to submit for you guy's to decide.

So here you go(still need to go into the other directories,
and will later on) but for now hope you like what you see,
and if you see something that might need changing send me a post.



  security/selinux/avc.c       |   21 ++--
  security/selinux/hooks.c     |  265 
+++++++++++++++++++++---------------------
  security/selinux/netif.c     |   12 +-
  security/selinux/netlabel.c  |   10 +-
  security/selinux/netnode.c   |   20 ++--
  security/selinux/netport.c   |   12 +-
  security/selinux/selinuxfs.c |   61 +++++-----
  security/selinux/xfrm.c      |   26 ++--
  8 files changed, 213 insertions(+), 214 deletions(-)


