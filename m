Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649AbXFORUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbXFORUg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 13:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbXFORU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 13:20:29 -0400
Received: from aa012msr.fastwebnet.it ([85.18.95.72]:55805 "EHLO
	aa012msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbXFORU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 13:20:28 -0400
Date: Fri, 15 Jun 2007 19:19:22 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: "Simon Arlott" <simon@fire.lp0.eu>
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>,
       "markus reichelt" <ml@mareichelt.de>, linux-kernel@vger.kernel.org
Subject: Re: /dev/loop* devices not appearing in /dev (at least since     
 2.6.22-rc3*)
Message-ID: <20070615191922.4dbaba84@localhost>
In-Reply-To: <42688.simon.1181906375@5ec7c279.invalid>
References: <e85b9d30706140437s5f3622c3rc86c75a4f845e7a3@mail.gmail.com>
	<20070614125224.GA4155@tatooine.rebelbase.local>
	<Pine.LNX.4.64.0706151101070.32724@fbirervta.pbzchgretzou.qr>
	<42688.simon.1181906375@5ec7c279.invalid>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2007 12:19:35 +0100
"Simon Arlott" <simon@fire.lp0.eu> wrote:

> > It *is* a good idea. MD works that way too.  
> 
> There's a patch around somewhere to create at least 8 devices, I don't know why it's not in Linus' tree yet...

It is! It's just that it was applied after -rc4...

commit a47653fc2643cf61bcabba8c9ff5c45517c089ba
Author: Ken Chen <kenchen@google.com>
Date:   Fri Jun 8 13:46:44 2007 -0700

    loop: preallocate eight loop devices

[...]

-- 
	Paolo Ornati
	Linux 2.6.22-rc4-cfs-v16-g47932c49 on x86_64
