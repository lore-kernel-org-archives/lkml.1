Return-Path: <linux-kernel-owner+w=401wt.eu-S1758084AbZFZK4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084AbZFZK4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 06:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbZFZK4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 06:56:37 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:54291 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbZFZK4g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 06:56:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nQP1Kpu9hEMHt820j6heOX4n3aLr+qk9FvGhEVfMh7u3D9i38HmJ+t0OLYBM/fcvP4
         uvijQzr5HS/jSgmvc0OwQiWd1kwVQEof4lJJzKRi982XcZmdfx/9DbTV5SIdDXBddq5F
         WkYalg3eGdTFtP2XJuLLPimUMFa73kYia0RkA=
MIME-Version: 1.0
In-Reply-To: <20090625230535.GE1723@ldl.fc.hp.com>
References: <20090610194714.28982.51363.stgit@bob.kio>
	 <20090610195600.28982.3404.stgit@bob.kio>
	 <81b0412b0906251538j2614bf91ya2edbaf120796dfc@mail.gmail.com>
	 <20090625230535.GE1723@ldl.fc.hp.com>
Date: Fri, 26 Jun 2009 12:56:35 +0200
Message-ID: <81b0412b0906260356p12fd7807y40223175bf785cc0@mail.gmail.com>
Subject: Re: [PATCH v3 11/12] ACPI: video: convert to acpi_get_pci_dev
From: Alex Riesen <raa.lkml@gmail.com>
To: Alex Chiang <achiang@hp.com>
Cc: lenb@kernel.org, twmoure@szypr.net, alessandro.suardi@gmail.com,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/26 Alex Chiang <achiang@hp.com>:
> Thanks for the bug report and sorry for the troubles.
>
> I've already got a debug patch here:
>
>        http://thread.gmane.org/gmane.linux.kernel/857228/focus=857468
>
> Perhaps you can try it too?

Will do soon.

> Len, in the mean time, can you please apply this as an emergency,
> "let's not crash anyone else's machine" while I try and figure
> out why the ACPI video driver breaks my assumptions?

This patch helped, does not panic anymore.
