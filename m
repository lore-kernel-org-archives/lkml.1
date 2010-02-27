Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936362Ab0B0WSW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 17:18:22 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:44569 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936351Ab0B0WST convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 17:18:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PxC42zVrzQYq90++d8sLuH9ewm0A5G7iCS1cFt/I0bvzyin73JThPYffwaCNI3NaFK
         ipwqrFVBXZrhgJ4NDn8Kxk278jw0hJu98Jtgh2vTpMn01v81MbbohwWzNSg5k6NDIYv2
         oc5qixRdEknxlYptFwb/5tVkwN+tXj0HLT8Yc=
MIME-Version: 1.0
In-Reply-To: <1267289508-31031-33-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
	 <1267289508-31031-33-git-send-email-andrea.gelmini@gelma.net>
Date: Sat, 27 Feb 2010 23:18:18 +0100
X-Google-Sender-Auth: 31a83ffd947d1036
Message-ID: <7d01f9f01002271418j185821a3h447c89a43406254d@mail.gmail.com>
Subject: Re: [PATCH 32/66] arch/parisc/include/asm/parport.h: Checkpatch 
	cleanup
From: Thibaut VARENE <T-Bone@parisc-linux.org>
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Helge Deller <deller@gmx.de>,
       "James E.J. Bottomley" <jejb@parisc-linux.org>,
       linux-parisc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27, 2010 at 5:51 PM, Andrea Gelmini
<andrea.gelmini@gelma.net> wrote:
> arch/parisc/include/asm/parport.h:1: ERROR: trailing whitespace
> arch/parisc/include/asm/parport.h:11: WARNING: space prohibited between function name and open parenthesis '('
>
> Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
> ---
>  arch/parisc/include/asm/parport.h |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/arch/parisc/include/asm/parport.h b/arch/parisc/include/asm/parport.h
> index 00d9cc3..5cbf98b 100644
> --- a/arch/parisc/include/asm/parport.h
> +++ b/arch/parisc/include/asm/parport.h

> @@ -8,8 +8,7 @@
>  #define _ASM_PARPORT_H 1
>
>
> -static int __devinit parport_pc_find_nonpci_ports (int autoirq, int autodma)
> -{
> +static int __devinit parport_pc_find_nonpci_ports (int autoirq, int autodma) {

This looks very much in contradiction with CodingStyle, since
parport_pc_find_nonpci_ports() is a function, and it's not a fix for
the quoted "WARNING". I'm guessing this wasn't intended the way it is.

HTH

T-Bone

-- 
Thibaut VARENE
http://www.parisc-linux.org/~varenet/
