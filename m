Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbYCKTen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbYCKTen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 15:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbYCKTee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 15:34:34 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:45687 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbYCKTee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 15:34:34 -0400
Date: Tue, 11 Mar 2008 20:34:50 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Alejandro Riveira =?iso-8859-1?Q?Fern=E1ndez?= 
	<alejandro.riveira@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Secctions missmatches on latest git
Message-ID: <20080311193450.GA10688@uranus.ravnborg.org>
References: <1205251628.11568.4.camel@Varda>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1205251628.11568.4.camel@Varda>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 05:07:08PM +0100, Alejandro Riveira Fernández wrote:
> Hi;
>  I do not know if this reports are useful but FWIW...
>  I have compiled the kernel with this command line:
> 
>  make CONFIG_DEBUG_SECTION_MISMATCH=y  CC=gcc-4.2 -sj5 2> ../warnings.txt
> 
> and get this results:
...
There are ~10 patches pending to solve various section mismatch
warnings and most if not all the below are fixed. They are staged
in -mm, the acpi and pci trees for now.

Will hit mainline in next merge window.
But thanks for the report anyway!

	Sam
