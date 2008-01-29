Return-Path: <linux-kernel-owner+w=401wt.eu-S933467AbYA2Tzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933467AbYA2Tzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 14:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765196AbYA2Tzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 14:55:35 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:40827 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765176AbYA2Tze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 14:55:34 -0500
Date: Tue, 29 Jan 2008 20:55:32 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [RFC] __ref annotation of function/data referencing __init/__exit
In-Reply-To: <20080128213811.GE3842@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0801292053531.14907@fbirervta.pbzchgretzou.qr>
References: <20080126184454.GA25591@uranus.ravnborg.org>
 <20080128213811.GE3842@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 28 2008 22:38, Sam Ravnborg wrote:
>On Sat, Jan 26, 2008 at 07:44:54PM +0100, Sam Ravnborg wrote:
>> Today we have the following annotations for functions/data
>> referencing __init/__exit functions / data:
>> 
>> __init_refok for functions
>> __initdata_refok for data
>> 
>> and
>> _exit_refok for functions
>> 
>> To simplify it and to introduce a shorter annotation I
>> will suggest the following annotation:
>> 
>> __ref      <= for functions (code) that
>>               references __*init / __*exit
>> __refdata  <= for variables
>> __refconst <= for const variables
>>
>
>This patch was includedin todays kbuild.git submission
>as I heard no negative feedback.

I would like to see some real-world example of __ref*.
When would you want to "reference" (function pointer?) an __init
function from outside another __init function?
