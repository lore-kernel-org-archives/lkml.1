Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbZFFKjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbZFFKjy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 06:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbZFFKjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 06:39:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:50055 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875AbZFFKjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 06:39:45 -0400
Subject: Re: [PATCH-tip] x86: hwmon/k8temp.c Add support for AMD 10H and 11H
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Rudolf Marek <r.marek@assembler.cz>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
In-Reply-To: <1243352672.31783.10.camel@localhost.localdomain>
References: <1242979484.8796.7.camel@localhost.localdomain>
	 <4A165F67.3020005@assembler.cz>
	 <1242981748.10642.3.camel@localhost.localdomain>
	 <1242984648.16532.3.camel@localhost.localdomain>
	 <4A182B61.5010503@assembler.cz>
	 <1243339833.12303.2.camel@localhost.localdomain>
	 <4A1C08C6.7060103@assembler.cz>
	 <1243352672.31783.10.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 06 Jun 2009 16:06:34 +0530
Message-Id: <1244284594.2475.53.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rudolf,

On Tue, 2009-05-26 at 21:14 +0530, Jaswinder Singh Rajput wrote:
> On Tue, 2009-05-26 at 17:20 +0200, Rudolf Marek wrote:
> > Hello,
> > 
> > Sorry I disagree. Lets skip whole 10H. I failed many times to get some useful 
> > info from AMD about this issue. I'm strongly against to impose some limits which 
> > might indicate what is OK and what is not.
> > 
> 
> OK, So here is new patch after skipping 10H. I hope I will get ack
> now ;-)
> 
> Subject: [PATCH] x86: hwmon/k8temp.c Add support for AMD 11H
> 
> This patch will also work for AMD 10H. But we are skipping it as :
> 
> AMD 10H cpus reports Inaccurate Temperature Measurement:
> http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/41322.pdf
> Errata #319
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---

As per your suggestion I skipped whole 10H. Have you queued this patch
or there is still some issues left.

Thanks,
--
JSR

