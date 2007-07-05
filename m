Return-Path: <linux-kernel-owner+w=401wt.eu-S1761410AbXGERW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761410AbXGERW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 13:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758694AbXGERWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 13:22:21 -0400
Received: from terminus.zytor.com ([192.83.249.54]:44856 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758708AbXGERWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 13:22:19 -0400
Message-ID: <468D28BF.5020404@zytor.com>
Date: Thu, 05 Jul 2007 10:22:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Karel Zak <kzak@redhat.com>,
       List util-linux-ng <util-linux-ng@vger.kernel.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng 2.13-rc1
References: <20070703221156.GY14825@petra.dvoda.cz> <Pine.LNX.4.64.0707041308330.1536@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0707041308330.1536@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jul 4 2007 00:11, Karel Zak wrote:
>> newgrp:
>> 	add support for /etc/gshadow
>> 	check result from getgrnam() more carefully
> 
> Hm, gshadow looks like it is really obsolete. (There is no such file anymore in
> suse releases since a long while. Previously, gshadow was filled with all the
> groups that existed.)
> 

gshadow is used when you have groups which have passwords, which is very
rare in practice but permitted in theory.

	-hpa
