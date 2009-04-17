Return-Path: <linux-kernel-owner+w=401wt.eu-S1757647AbZDQFBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647AbZDQFBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 01:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbZDQFBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 01:01:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:10889 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbZDQFBW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 01:01:22 -0400
MIME-Version: 1.0
In-Reply-To: <74c0088dfda1816c21914c0a8da0c42908526c5e.1239874968.git.monstr@monstr.eu>
References: <1239875798-10523-1-git-send-email-monstr@monstr.eu>
	 <708dba6c793117ed9ee1036cae48ed9288d328b8.1239874968.git.monstr@monstr.eu>
	 <1f1874e0192d8481356551ffbeeebcecce951afc.1239874968.git.monstr@monstr.eu>
	 <157375351273eacf9b552e677447505542f90521.1239874968.git.monstr@monstr.eu>
	 <f87119e246276eb41047985c97b74a5b79adc259.1239874968.git.monstr@monstr.eu>
	 <a3f7086da43a5d4f994344a07a75568f679095d6.1239874968.git.monstr@monstr.eu>
	 <74602b0d6e166c6a657f3d9b7f6c3890b0783326.1239874968.git.monstr@monstr.eu>
	 <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
	 <c92f8e48fb760c385438885b4a2c79c50a213f3b.1239874968.git.monstr@monstr.eu>
	 <74c0088dfda1816c21914c0a8da0c42908526c5e.1239874968.git.monstr@monstr.eu>
Date: Fri, 17 Apr 2009 15:01:21 +1000
Message-ID: <1d3f23370904162201s21fc7d90q8bc4aacafa5a7ada@mail.gmail.com>
Subject: Re: [microblaze-uclinux] [PATCH 11/11] microblaze: Kconfig: Enable 
	drivers for Microblaze
From: John Williams <john.williams@petalogix.com>
To: microblaze-uclinux@itee.uq.edu.au
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 7:56 PM,  <monstr@monstr.eu> wrote:
> From: Michal Simek <monstr@monstr.eu>
>
> Signed-off-by: Michal Simek <monstr@monstr.eu>

ACK from a MicroBlaze perspective, but some other comments below:

A note more for the Xilinx PPC folks (ie Grant Likely):

Shouldn't some of these Kconfig depends for PPC be unified?  We have:

>  config XILINX_SYSACE
>        tristate "Xilinx SystemACE support"
> -       depends on 4xx
> +       depends on 4xx || MICROBLAZE

>  config XILINX_HWICAP
>        tristate "Xilinx HWICAP Support"
> -       depends on XILINX_VIRTEX
> +       depends on XILINX_VIRTEX || MICROBLAZE


>  config GPIO_XILINX
>        bool "Xilinx GPIO support"
> -       depends on PPC_OF
> +       depends on PPC_OF || MICROBLAZE
>        help
>          Say yes here to support the Xilinx FPGA GPIO device

Are these all really different options?  PPC_OF?  XILINX_VIRTEX?  4xx?

John
