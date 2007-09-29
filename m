Return-Path: <linux-kernel-owner+w=401wt.eu-S1758149AbXI2SHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149AbXI2SHd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 14:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbXI2SH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 14:07:26 -0400
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:59473 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754213AbXI2SHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 14:07:25 -0400
Date: Sat, 29 Sep 2007 20:07:21 +0200
From: Wolfgang Erig <Wolfgang.Erig@gmx.de>
To: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: regression in 2.6.23-rc8 - power off failed
Message-ID: <20070929180721.GA8371@erig.dyndns.org>
Mail-Followup-To: "H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org,
	Alexey Starikovskiy <astarikovskiy@suse.de>
References: <20070929005453.GA4475@erig.dyndns.org> <46FDC0EB.3070003@zytor.com> <20070929082233.GA3447@erig.dyndns.org> <46FE0D29.4090706@zytor.com> <20070929093553.GA4451@erig.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070929093553.GA4451@erig.dyndns.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Sat, Sep 29, 2007 at 11:35:53AM +0200, Wolfgang Erig wrote:
>
> I start again with a fresh tree and better controlled experiments.

now the result of bisection seems to be consistent.

The last good commit is
f2d98ae63dc64dedb00499289e13a50677f771f9 Linker script for the new x86 setup code

The first bad commit (no power off) is
4fd06960f120e02e9abc802a09f9511c400042a5 Use the new x86 setup code for i386

Now I try the things written in
http://marc.info/?i=46FD802D.2030804@zytor.com

Wolfgang
