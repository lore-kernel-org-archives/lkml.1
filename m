Return-Path: <linux-kernel-owner+w=401wt.eu-S1759997AbYBAVrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997AbYBAVrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 16:47:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755665AbYBAVr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 16:47:28 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:51952 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452AbYBAVr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 16:47:27 -0500
Date: Fri, 1 Feb 2008 22:47:25 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Are Section mismatches out of control?
In-Reply-To: <1201864894.23523.117.camel@brick>
Message-ID: <Pine.LNX.4.64.0802012245250.18790@fbirervta.pbzchgretzou.qr>
References: <20080201104718.GA11717@uranus.ravnborg.org> 
 <20080201030329.9b760777.akpm@linux-foundation.org> <1201864894.23523.117.camel@brick>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 1 2008 03:21, Harvey Harrison wrote:
>> 
>> Question is: why do people keep adding new ones when they are so easy to
>> detect and fix?
>> 
>> Asnwer: because neither they nor their patch integrators are doing adequate
>> compilation testing.
>
>[...]
>Unless they break the build, or if there currently are 0 and they make
>it non-zero, people seem not to care....sad.  Probably the same for
>sparse/checkpatch, "there's plenty already, I can't be bothered to look"

checkpatch does not parse C, it uses heuristical regexes.

That makes it very different from sparse or the section mismatch
finder which do not output false positives.
