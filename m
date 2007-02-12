Return-Path: <linux-kernel-owner+w=401wt.eu-S933029AbXBLP4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933029AbXBLP4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 10:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933034AbXBLP4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 10:56:34 -0500
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:24833 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933028AbXBLP4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 10:56:33 -0500
Message-ID: <45D08E2B.4010400@fr.ibm.com>
Date: Mon, 12 Feb 2007 16:56:27 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: menage@google.com, vatsa@in.ibm.com, sekharan@us.ibm.com,
       ckrm-tech@lists.sourceforge.net, xemul@sw.ru,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org, pj@sgi.com,
       ebiederm@xmission.com, winget@google.com, rohitseth@google.com
Subject: Re: [PATCH 3/7] containers (V7): Add generic multi-subsystem API
 to containers
References: <20070212081521.808338000@menage.corp.google.com> <20070212085104.485337000@menage.corp.google.com> <20070212153949.GA16014@sergelap.austin.ibm.com>
In-Reply-To: <20070212153949.GA16014@sergelap.austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> +#include <asm/proto.h>
> 
> I did have a problem with this include.  On s390 it didn't exist so I've
> just been running without it (with no problems).  A quick 'find'
> suggests it only exists on x86_64, so I'd expect failures on all other
> arches.

confirmed on x86 also.

C.
