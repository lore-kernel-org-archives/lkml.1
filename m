Return-Path: <linux-kernel-owner+w=401wt.eu-S1751933AbZH1GbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbZH1GbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 02:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbZH1GbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 02:31:24 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:16917 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbZH1GbY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 02:31:24 -0400
Message-Id: <4A9795DC0200007800012068@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 28 Aug 2009 07:31:24 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Tejun Heo" <tj@kernel.org>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: make use of inc/dec conditional
References: <4A8BCA850200007800010836@vpn.id2.novell.com>
 <4A8C2CDE.1010405@zytor.com> <4A8D13740200007800010BC7@vpn.id2.novell.com>
 <4A9636EB.7020408@kernel.org>
In-Reply-To: <4A9636EB.7020408@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Tejun Heo <tj@kernel.org> 27.08.09 09:34 >>>
>For the percpu part, wouldn't it be better to have
>__builtin_contant_p() on the add/sub parameter, use inc/dec if the
>param is constant and 1 and make simple wrapper for inc/dec if still
>necessary?

Hmm, yes, I should give this a try.

Jan

