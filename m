Return-Path: <linux-kernel-owner+w=401wt.eu-S1752192AbZEYNqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbZEYNqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 09:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbZEYNp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 09:45:57 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:17011 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbZEYNp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 09:45:56 -0400
Date: Mon, 25 May 2009 15:45:01 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Rudolf Marek <r.marek@assembler.cz>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH-tip] x86: hwmon/k8temp.c Add support for 
 AMD 10H and 11H
Message-ID: <20090525154501.3f251a23@hyperion.delvare>
In-Reply-To: <1242984648.16532.3.camel@localhost.localdomain>
References: <1242979484.8796.7.camel@localhost.localdomain>
	<4A165F67.3020005@assembler.cz>
	<1242981748.10642.3.camel@localhost.localdomain>
	<1242984648.16532.3.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaswinder,

On Fri, 22 May 2009 15:00:48 +0530, Jaswinder Singh Rajput wrote:
> Atleast something is better than nothing ;-)

Sorry but you are wrong here. When it comes to hardware monitoring (or
monitoring in general), potentially wrong data is _worse_ than no data
at all, unless you additionally carry the information that the data
value may be wrong, and display it in a very visible manner. As our
sysfs interface doesn't provide any way to pass reliability information
to the reader (and I don't think it would make sense to add one), it is
better to not export data that we know can't be trusted.

-- 
Jean Delvare
