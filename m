Return-Path: <linux-kernel-owner+w=401wt.eu-S1758072AbYAYRxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072AbYAYRxD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 12:53:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbYAYRww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 12:52:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59253 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbYAYRwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 12:52:51 -0500
Message-ID: <479A21EA.4040201@zytor.com>
Date: Fri, 25 Jan 2008 09:52:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jack Harvard <jack.harvard@googlemail.com>
CC: Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
Subject: Re: Q: linux failed to execute /init?
References: <a72f6a3c0801250538m57a91629o59242fad9e7d0265@mail.gmail.com>	 <a72f6a3c0801250540l73aacf9bvcebf50c23da3943e@mail.gmail.com>	 <Pine.LNX.4.64.0801251524510.15243@fbirervta.pbzchgretzou.qr>	 <a72f6a3c0801250639i4a7858eem415594f5663a9c7e@mail.gmail.com>	 <Pine.LNX.4.64.0801251601360.15243@fbirervta.pbzchgretzou.qr> <a72f6a3c0801250734hdad822akce2808af7f9c4a83@mail.gmail.com>
In-Reply-To: <a72f6a3c0801250734hdad822akce2808af7f9c4a83@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jack Harvard wrote:
> This is reproduceable and it happens every time. IMHO, I also suspect
> this could be caused by some obscure timing issues, as the kernel is
> booting up from an FPGA-prototyped SoC, the same Linux image was
> running fine on a previous build of FPGA-prototyped SoC,  but it's
> coming across this /init failed problem repeatedly on the currently
> running newly built bit file.

Sounds like a problem in your drivers, and/or your memory controller. 
Especially the memory controller.

	-hpa
