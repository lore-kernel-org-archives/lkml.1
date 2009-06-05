Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbZFENYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbZFENYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 09:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbZFENYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 09:24:35 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:33222 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430AbZFENYe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:24:34 -0400
Message-Id: <4A2938B302000078000049D7@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 05 Jun 2009 14:24:35 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Cc: <linux-kernel@vger.kernel.org>
Subject: num_physpages vs. totalram_pages
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty,

in a mail from beginning of last year you indicated that the confusion between
these two variables should be cleaned up. Since I wasn't able to spot any
follow-up regarding this matter, I'm wondering what the plan here is. I'm
asking because we have got customers reporting inconsistencies mainly caused
by the use of num_physpages where totalram_pages would really be more
appropriate (other than in your mail, where you mainly point at the networking
code, this is with the determination of the number of files the system will use
without admin involvement), due to large sparse areas in the physical address
map.

Unfortunately, the meaning of num_physpages seems to also vary between
architectures (some treat it as being the same as totalram_pages) as well as
subsystems (memory hotplug increments/decrements num_physpages along
with totalram_pages).

Thanks, Jan

