Return-Path: <linux-kernel-owner+w=401wt.eu-S1761626AbYB1ASf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761626AbYB1ASf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 19:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755207AbYB1AS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 19:18:27 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:43895 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133AbYB1AS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 19:18:27 -0500
Date: Thu, 28 Feb 2008 01:18:23 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: SL Baur <steve@xemacs.org>
cc: Richard Knutsson <ricknu-0@student.ltu.se>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>, bhalevy.lists@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CodingStyle: multiple updates
In-Reply-To: <ed10ee420802271611l3a09e76ej531158f167512a03@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802280116260.5388@fbirervta.pbzchgretzou.qr>
References: <1204062430.47c488def40a4@portal.student.luth.se> 
 <20080226135444.f83a0536.randy.dunlap@oracle.com> 
 <Pine.LNX.4.64.0802262310050.15321@fbirervta.pbzchgretzou.qr> 
 <Pine.LNX.4.64.0802270033310.5714@axis700.grange>  <m31w6zcm4l.fsf@maximus.localdomain>
  <ed10ee420802261657w3830e1a1rf0cc9601cdacb142@mail.gmail.com> 
 <20080226213432.1388717b.randy.dunlap@oracle.com>  <47C5DDE0.3040403@student.ltu.se>
 <ed10ee420802271611l3a09e76ej531158f167512a03@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 27 2008 16:11, SL Baur wrote:
>On 2/27/08, Richard Knutsson <ricknu-0@student.ltu.se> wrote:
>
>>  Actually, I see this as an quite simple question: is tab _the
>>  indention-marker_? If not, then why the refusal of spaces indents (or mix)?
>
>Because mixing spaces and tabs is often ugly.  8 spaces and a
>single tab often do not have the same width when you're viewing
>the text in a variable width font.

By the way, neither tab nor bunch-a'-spaces makes alignment look good.
Try:

	/* fails when !monospace || tab != 8 */
	fprintf(fp, KERN_WARNING
		"Opening quotes should be right after (");

	/* fails if !monospace */
	fprintf(fp, KERN_WARNING
	        "Opening quotes should be right after (");

hm... :-/
