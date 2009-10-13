Return-Path: <linux-kernel-owner+w=401wt.eu-S1759693AbZJMMgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759693AbZJMMgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 08:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759648AbZJMMgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 08:36:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:42133 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759440AbZJMMgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 08:36:11 -0400
Message-ID: <4AD473F9.7090606@kernel.org>
Date: Tue, 13 Oct 2009 21:35:05 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alexander Huemer <alexander.huemer@sbg.ac.at>
CC: Jean Delvare <jdelvare@suse.de>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: 2.6.{30,31} x86_64 ahci problem - irq 23: nobody cared
References: <4ABBB8C2.2080901@sbg.ac.at> <200910101513.51320.elendil@planet.nl> <4AD2DFA4.9000602@kernel.org> <200910121148.16439.elendil@planet.nl> <4AD2FC60.8080705@kernel.org> <4AD2FD10.2010800@sbg.ac.at> <4AD2FFC7.5010402@kernel.org> <4AD300B5.6080102@sbg.ac.at> <4AD34554.3050701@sbg.ac.at> <4AD3E348.5030508@kernel.org> <4AD422F2.4080308@sbg.ac.at>
In-Reply-To: <4AD422F2.4080308@sbg.ac.at>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Oct 2009 12:35:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Huemer wrote:
> i compiled gcc in a loop over night, 14 times. no error.
> it really seams i2c_i801 was the cause...
> unfortunately i still don't know how i can extract the part of the gcc
> compilation process that causes the error on an affected kernel.
> that would enable me to create a simple test program.

Given that i2c is used for temperature monitoring, I think it is not
triggered by any single step of the compiling but rather by the
accumulated heat load during compilation.  Let's wait for Jean to
chime in.  :-)

Thanks.

-- 
tejun
