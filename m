Return-Path: <linux-kernel-owner+w=401wt.eu-S1755137AbZFGAIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbZFGAIS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 20:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbZFGAII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 20:08:08 -0400
Received: from ozlabs.org ([203.10.76.45]:57356 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538AbZFGAII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 20:08:08 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Jan Beulich" <JBeulich@novell.com>
Subject: Re: num_physpages vs. totalram_pages
Date: Sun, 7 Jun 2009 09:38:02 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <4A2938B302000078000049D7@vpn.id2.novell.com>
In-Reply-To: <4A2938B302000078000049D7@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906070938.03131.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jun 2009 10:54:35 pm Jan Beulich wrote:
> Rusty,
>
> in a mail from beginning of last year you indicated that the confusion
> between these two variables should be cleaned up. Since I wasn't able to
> spot any follow-up regarding this matter, I'm wondering what the plan here
> is. I'm asking because we have got customers reporting inconsistencies
> mainly caused by the use of num_physpages where totalram_pages would really
> be more appropriate (other than in your mail, where you mainly point at the
> networking code, this is with the determination of the number of files the
> system will use without admin involvement), due to large sparse areas in
> the physical address map.
>
> Unfortunately, the meaning of num_physpages seems to also vary between
> architectures (some treat it as being the same as totalram_pages) as well
> as subsystems (memory hotplug increments/decrements num_physpages along
> with totalram_pages).

Unfortunately, I have not even thought about it between then and now.  I look 
forward to your proposal!

Rusty.
