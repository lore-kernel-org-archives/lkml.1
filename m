Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbYANKd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbYANKd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 05:33:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755916AbYANKdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 05:33:39 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:5781 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755852AbYANKdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 05:33:37 -0500
X-SBRS: None
X-MesageID: 37611252
X-Ironport-Server: ftlpip02.citrite.net
X-Remote-IP: 216.142.71.134
X-Policy: $Relay
X-IronPort-AV: E=Sophos;i="4.24,281,1196658000"; 
   d="scan'208";a="37611252"
Date: Mon, 14 Jan 2008 10:27:06 +0000
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Default keyboard LEDs
Message-ID: <20080114102706.GB4298@implementation.uk.xensource.com>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080114005219.GA4296@implementation> <478ADC0A.7020006@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <478ADC0A.7020006@zytor.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin, le Sun 13 Jan 2008 19:50:34 -0800, a écrit :
> >Actually, what would be perfect would be to use the configuration that
> >the BIOS sets at boot by default.  That is device-dependent, however.
> >
> 
> It is, but it can be read out either by INT calls at initialization 
> time, or by reading out the byte at physical address 0x417:

I should have said "arch-dependent".
I didn't mean it wasn't possible, but just it'd probably be better that
driver experts do it, not me :)

> --------K-M00400017--------------------------
> MEM 0040h:0017h - KEYBOARD - STATUS FLAGS 1
> Size:   BYTE
> SeeAlso: MEM 0040h:0018h,INT 16/AH=02h,MEM 0040h:0096h
> 
> Bitfields for keyboard status flags 1:
> Bit(s)  Description     (Table M0010)
>  7      INSert active
>  6      Caps Lock active
>  5      Num Lock active
>  4      Scroll Lock active
>  3      either Alt pressed
>  2      either Ctrl pressed
>  1      Left Shift pressed
>  0      Right Shift pressed
> SeeAlso: #M0011,#00587
> 
> The same information is available through INT 16h, AH=02h.

Samuel
