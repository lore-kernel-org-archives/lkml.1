Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab0BSNNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 08:13:13 -0500
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:55365 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752062Ab0BSNNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 08:13:10 -0500
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host o1JDCv1I012046
Subject: Re: [PATCH] LSM: add static to security_ops variable
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: wzt wzt <wzt.wzt@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       sds@tycho.nsa.gov, jmorris@namei.org, eparis@parisplace.org
In-Reply-To: <628d1651002190423s4590bbc5x2eeff6792619f591@mail.gmail.com>
References: <628d1651002070324w424012eanda9392db26331905@mail.gmail.com>
	 <b6fcc0a1002190344s75ecfcf6y625591a0fa8e9869@mail.gmail.com>
	 <628d1651002190357q1b17cf76o6585ce957d610ed8@mail.gmail.com>
	 <b6fcc0a1002190402y7aeef6bana21ad7d54a32777a@mail.gmail.com>
	 <628d1651002190423s4590bbc5x2eeff6792619f591@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Feb 2010 14:12:57 +0100
Message-ID: <1266585177.31443.17.camel@thorin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-DCC-URT-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fre, 2010-02-19 at 20:23 +0800, wzt wzt wrote:
> > It's not a barrier, it's garbage. Once you know the adress security_ops
> > ended up at, you simply write to it.
> 
> How to find the security_ops address if the variable is static? Would
> you please make an example?
- Find the accessor function (which is surely non-static).
- Find the address where writes the parameter.

Other must decide, if it's more secure (as in "obscure") with the
accessor funtion or not.

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

