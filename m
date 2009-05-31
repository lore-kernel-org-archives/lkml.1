Return-Path: <linux-kernel-owner+w=401wt.eu-S1756616AbZEaPa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbZEaPa1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 11:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755567AbZEaPaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 11:30:17 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:34517 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbZEaPaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 11:30:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=DrQOmzdozb3d89FkC33DuO2awtGa6qyaj7suwGRM/FACLZkAxkcIbr4waAlTH/q8kJ
         OQuzsGWdLYFrppIe3TR/V4lJZDGe3/Ij/Yf8eA94N8DzkK1SZrLPcKJmaXXnWHdgW/fe
         xnqw+cESERM78DDuePnO453cfz7lsgZa/nl9M=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
Subject: Re: [PATCH 0/4] partitions/ide: improve Host Protected Area handling
Date: Sun, 31 May 2009 17:34:54 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc7-next-20090529-06589-g7701864-dirty; KDE/4.2.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Robert Hancock <hancockrwd@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Frans Pop <elendil@planet.nl>
References: <20090531143911.7164.26834.sendpatchset@localhost.localdomain> <20090531152403.GA26987@ub>
In-Reply-To: <20090531152403.GA26987@ub>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905311735.01244.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 31 May 2009 17:24:03 Andries E. Brouwer wrote:
> On Sun, May 31, 2009 at 04:39:11PM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> [HPA stuff deleted]
> 
> Hi Bartlomiej,
> 
> Apart from HPA one also has DCO, which functions rather similarly.
> (I have not checked whether the current kernel knows anything about DCO.)
> Have you thought about DCO?
> Probably the kernel should by default not touch any such setting.
> Maybe it should be reported?
> A user space utility might change this setting - thus a disk can change size.

We leave DCO handling entirely to user-space currently.
