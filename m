Return-Path: <linux-kernel-owner+w=401wt.eu-S1758021AbYBYTCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021AbYBYTCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 14:02:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755236AbYBYTBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 14:01:55 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:50739 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754555AbYBYTBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 14:01:54 -0500
X-Sasl-enc: ziva/CyXAUi/1/zPHJ2JbfLV7aJxTTRFBcs96hjImFEk 1203966112
Date: Mon, 25 Feb 2008 16:01:49 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: linux-kernel@vger.kernel.org, len.brown@intel.com
Subject: Re: latest commit on thinkpad_acpi.c 6c231bd5eb07 shows warning
Message-ID: <20080225190149.GD16513@khazad-dum.debian.net>
References: <c4e36d110802241407q4808e3f8n318723a70696fd0d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4e36d110802241407q4808e3f8n318723a70696fd0d@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2008, Zdenek Kabelac wrote:
> Commit 6c231bd5eb07ce546517019f334652b9ecfc329a
> generate this warning:
> 
> drivers/misc/thinkpad_acpi.c: In function 'tpacpi_input_send_tabletsw':
> include/linux/input.h:1290: warning: 'state' is used uninitialized in
> this function
> drivers/misc/thinkpad_acpi.c:1191: note: 'state' was declared here
> drivers/misc/thinkpad_acpi.c: In function 'hotkey_tablet_mode_show':
> drivers/misc/thinkpad_acpi.c:1723: warning: 's' is used uninitialized
> in this function

I can't seem to get these warnings in Debian gcc 4.2.3-1.  But the code is
broken alright.  I will send in a fix in a short while, as it will take a
small while to make sure there is nothing else wrong before I send in the
fix.   I have to figure out how the heck that got past the testing in the
first place, as well...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
