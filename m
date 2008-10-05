Return-Path: <linux-kernel-owner+w=401wt.eu-S1755060AbYJENvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbYJENvw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 09:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbYJENvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 09:51:43 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:38754 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753806AbYJENvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 09:51:42 -0400
X-Sasl-enc: pn9/myimH4jWamXQvtdsftHB3CSkVwQqTtNJDsdNIIGB 1223214701
Date: Sun, 5 Oct 2008 10:51:37 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: dmitry.torokhov@gmail.com, IvDoorn@gmail.com, sitsofe@yahoo.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rfkill-input doesn't work until 5 minutes after boot
Message-ID: <20081005135136.GA4389@khazad-dum.debian.net>
References: <20081004204342.GA29620@srcf.ucam.org> <20081005004334.GA31844@srcf.ucam.org> <20081005110226.GB4087@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081005110226.GB4087@srcf.ucam.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 05 Oct 2008, Matthew Garrett wrote:
> rfkill-input implements debounce as follows:
> 
>         if (time_after(jiffies, task->last + msecs_to_jiffies(200))) {
> 
> However, task->last is initialised to 0 while jiffies starts at -300*HZ. 
> Any input within 5 minutes of kernel start is therefore ignored. Fix by 
> initialising task->last correctly.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

FWIW:
Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
