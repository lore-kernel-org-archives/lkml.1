Return-Path: <linux-kernel-owner+w=401wt.eu-S1758051AbYBYTML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051AbYBYTML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 14:12:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbYBYTL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 14:11:58 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:49256 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbYBYTL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 14:11:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZhI/SFzCzFcZFbeTQvXiA225xfesk6da40eVif8GtFFAadHjFKfzYqQgcCUiLlUuzw6ZoTFBj0D3cCGn44mGuFIrF2gehP4R7ixL7uNQ52qHns25Vf7aAzKWqo6Mp7cMM6FiFiBuULrxjD9XTKO7QRTio5vEwnNCkZdfh9sX0kc=
Message-ID: <c4e36d110802251111m45a14375jf620b51229479c9b@mail.gmail.com>
Date: Mon, 25 Feb 2008 20:11:55 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: latest commit on thinkpad_acpi.c 6c231bd5eb07 shows warning
Cc: linux-kernel@vger.kernel.org, len.brown@intel.com
In-Reply-To: <20080225190149.GD16513@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110802241407q4808e3f8n318723a70696fd0d@mail.gmail.com>
	 <20080225190149.GD16513@khazad-dum.debian.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/2/25, Henrique de Moraes Holschuh <hmh@hmh.eng.br>:
> On Sun, 24 Feb 2008, Zdenek Kabelac wrote:
>
> > Commit 6c231bd5eb07ce546517019f334652b9ecfc329a
>  > generate this warning:
>  >
>  > drivers/misc/thinkpad_acpi.c: In function 'tpacpi_input_send_tabletsw':
>  > include/linux/input.h:1290: warning: 'state' is used uninitialized in
>  > this function
>  > drivers/misc/thinkpad_acpi.c:1191: note: 'state' was declared here
>  > drivers/misc/thinkpad_acpi.c: In function 'hotkey_tablet_mode_show':
>  > drivers/misc/thinkpad_acpi.c:1723: warning: 's' is used uninitialized
>  > in this function
>
>
> I can't seem to get these warnings in Debian gcc 4.2.3-1.  But the code is
>  broken alright.  I will send in a fix in a short while, as it will take a
>  small while to make sure there is nothing else wrong before I send in the
>  fix.   I have to figure out how the heck that got past the testing in the
>  first place, as well...

Try gcc-4.3  (or gcc-snapshot) - makes much better/deeper code analysis.

Zdenek
