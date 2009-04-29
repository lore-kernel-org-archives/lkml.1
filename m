Return-Path: <linux-kernel-owner+w=401wt.eu-S1761045AbZD2UAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761045AbZD2UAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 16:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbZD2UAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 16:00:36 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:46220 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755365AbZD2UAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 16:00:35 -0400
X-Sasl-enc: BkBxc2rBeHh4pkd95Sl3INhjFH0EPp/UPAyW0GP9PXRu 1241035234
Date: Wed, 29 Apr 2009 17:00:32 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>, Greg KH <greg@kroah.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: usbutils 0.81 release
Message-ID: <20090429200032.GD1598@khazad-dum.debian.net>
References: <20090427193532.GA2948@kroah.com> <8bd0f97a0904291053g3aa71decpd33f6621ad0bf9f8@mail.gmail.com> <20090429180735.GA29812@kroah.com> <8bd0f97a0904291117ic07fadcs2a02fca3dcfefcf0@mail.gmail.com> <ac3eb2510904291159s14d7d532q33657eb73007fc4b@mail.gmail.com> <20090429191841.GA1598@khazad-dum.debian.net> <ac3eb2510904291227v48628c8j181dffc8fdfa1de6@mail.gmail.com> <20090429195037.GC1598@khazad-dum.debian.net> <ac3eb2510904291255j2aee527bx8e32b356ad0260d1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510904291255j2aee527bx8e32b356ad0260d1@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009, Kay Sievers wrote:
> And if your distro updates the package, it overwrites the changes you
> did to the file, and they are lost?

I suppose so, and not just for package updates: if you run update-usbids,
the old one is overwritten AFAIK.  I didn't check the scripts, though.  But
as a long time Debian Developer and user, that's what is implied by its
location in /var.

If local admin changes are to be preserved, Debian policy mandates that it
belongs on /etc.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
