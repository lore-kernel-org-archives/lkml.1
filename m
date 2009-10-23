Return-Path: <linux-kernel-owner+w=401wt.eu-S1752041AbZJWLu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbZJWLu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 07:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbZJWLuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 07:50:25 -0400
Received: from host-181-75-169-83.static.internet-fr.net ([83.169.75.181]:48827
	"EHLO seanodes.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751970AbZJWLuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 07:50:25 -0400
Message-ID: <4AE19867.5070705@gmail.com>
Date: Fri, 23 Oct 2009 13:49:59 +0200
From: Erwan Velu <erwanaliasr1@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090822)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [PATCH] dmi_check_system can generate Warnings when no DMI table
 is present
References: <4AE178AF.3010804@gmail.com> <20091023110323.GC10071@elte.hu>
In-Reply-To: <20091023110323.GC10071@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> Looks like a Xen bug. DMI matching functions should be called after that 
> code has initialized. The warning was added to catch such early calls.
>
> Your patch works around that bug and the warning.
>   
So I think you'll drop it and we have to make xen people fix it ?
