Return-Path: <linux-kernel-owner+w=401wt.eu-S1757897AbXFSMgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897AbXFSMgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 08:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755041AbXFSMg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 08:36:29 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:53068
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754180AbXFSMg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 08:36:28 -0400
Date: Tue, 19 Jun 2007 14:38:03 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Shaun Savage <savages@savages.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: How do you allocate huge pages.
Message-ID: <20070619123803.GD22468@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Shaun Savage <savages@savages.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4677C702.6050102@savages.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4677C702.6050102@savages.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, Jun 19, 2007 at 05:07:30AM -0700 Shaun Savage ha dit:
 
> I am trying to allocate very large memory within the kernel. I want to
> start by allocating one huge (4M) page and using that as buffer space.

possibly vmalloc() is what you're looking for, if it isn't really a
*page* of 4M, what afaik is impossible with a standard kernel.

vmalloc() allocates virtually contiguous memory, as opposed to
kmalloc() which allocates physically contiguous memory.

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

     La libertad es como la mañana. Hay quienes esperan dormidos a que
   llegue, pero hay quienes desvelan y caminan la noche para alcanzarla
                        (Subcomandante Marcos)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
