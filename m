Return-Path: <linux-kernel-owner+w=401wt.eu-S1760122AbZDBMpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122AbZDBMpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 08:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbZDBMpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 08:45:40 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:21471 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbZDBMpj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 08:45:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=bgPXiO3DvCc3+FyELhAcYwB/UpJ7ilcm3jNFUFNWrmooZgqFHjEOM+tI5WtzVNVcoi
         Pw+ri690lEEhCklLVAOl96ZoLZ5tLNOMCc7mAYKbT6KnFOF3PnBxOsXYFWgUCYznm9xh
         UnMhCikW6ZrZfZOWmCnPjvZWtfKxaZ5iL3a3o=
MIME-Version: 1.0
Reply-To: petkovbb@gmail.com
In-Reply-To: <49D48600.2070109@garzik.org>
References: <49D48600.2070109@garzik.org>
Date: Thu, 2 Apr 2009 14:45:36 +0200
Message-ID: <9ea470500904020545q14cdad6cge385806f1d9da448@mail.gmail.com>
Subject: Re: IDE, packet commands and REQ_TYPE_SENSE?
From: Borislav Petkov <petkovbb@googlemail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> What are the differences between REQ_TYPE_ATA_PC and REQ_TYPE_BLOCK_PC?
>  Would it be possible to eliminate REQ_TYPE_ATA_PC after some work, as well?

That's the plan. However, I'd like to wait for Tejun's block patches
to get settled first,
especially the convert-to-bio from rq->data bits.

-- 
Regards/Gruss,
Boris
