Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbZLVTBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbZLVTBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 14:01:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbZLVTBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 14:01:45 -0500
Received: from anguilla.debian.or.at ([86.59.21.37]:55481 "EHLO
	anguilla.debian.or.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310AbZLVTBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 14:01:44 -0500
Date: Tue, 22 Dec 2009 20:01:43 +0100
From: Peter Palfrader <weasel@debian.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, DSA <debian-admin@lists.debian.org>,
       linux-input@vger.kernel.org
Subject: Re: 2.6.32.1: BUG and panic: unable to handle kernel NULL pointer dereference at 000000000000001f
Message-ID: <20091222190143.GO13850@anguilla.noreply.org>
Mail-Followup-To: Andi Kleen <andi@firstfloor.org>,
	linux-kernel@vger.kernel.org, DSA <debian-admin@lists.debian.org>,
	linux-input@vger.kernel.org
References: <20091215162736.GS13850@anguilla.noreply.org> <871vindxkv.fsf@basil.nowhere.org> <20091222183354.GM13850@anguilla.noreply.org> <20091222184215.GJ10314@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20091222184215.GJ10314@basil.fritz.box>
X-PGP: 1024D/94C09C7F 5B00 C96D 5D54 AEE1 206B  AF84 DE7A AF6E 94C0 9C7F
X-Request-PGP: http://www.palfrader.org/keys/94C09C7F.asc
X-Accept-Language: de, en
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Dec 2009, Andi Kleen wrote:

> > This is a static kernel - no module support.  Anyway, I also tried
> > without CONFIG_USB_HID (which pulls in all the other HID_* things) but
> > no luck.
> 
> Try a make distclean + rebuild anyways.

I usually do.  make-kpkg doesn't really like building from dirty
directories all that much.

-- 
                           |  .''`.  ** Debian GNU/Linux **
      Peter Palfrader      | : :' :      The  universal
 http://www.palfrader.org/ | `. `'      Operating System
                           |   `-    http://www.debian.org/
