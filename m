Return-Path: <linux-kernel-owner+w=401wt.eu-S1758890AbZENX11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890AbZENX11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 19:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbZENX1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 19:27:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:52739 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755930AbZENX1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 19:27:17 -0400
Content-Type: text/plain; charset="iso-8859-1"
Date: Fri, 15 May 2009 01:27:16 +0200
From: "Andrew Flach" <Andrew.Flach23@gmx.at>
Message-ID: <20090514232716.310530@gmx.net>
MIME-Version: 1.0
Subject: Uncacheable memory
To: linux-kernel@vger.kernel.org
X-Authenticated: #55945763
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX193EcsswzV3vcpeMqUpkArFKFGQpSlVOJR/I5j/4z
 NYFYv8ifS7LVrmLbQ/QGgM94snh6RDBGSB3Q== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: 45A5fgYzRkkNS1fQJmdqCHZudWkvKNPR
X-FuHaFi: 0.71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

For some simple tests I would like to specify some regions of an application program as uncacheable. For example, the application contains a function that maps to the memory address space 0x08002000 to 0x0800A000 in the executable. When this program is run, code within this address space should be marked as uncacheable and the Kernel should not store any data between 0x08002000 and 0x0800A000 in the cache. Is there an straightforward way to do that? Could this be realised with the PAT or do I need to have a look at the MTTR?

Thanks
-- 
Neu: GMX FreeDSL Komplettanschluss mit DSL 6.000 Flatrate + Telefonanschluss für nur 17,95 Euro/mtl.!* http://dslspecial.gmx.de/freedsl-surfflat/?ac=OM.AD.PD003K11308T4569a
