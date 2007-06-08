Return-Path: <linux-kernel-owner+w=401wt.eu-S970654AbXFHQ11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970654AbXFHQ11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968248AbXFHQ1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:27:13 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:38406 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S969278AbXFHQ1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:27:10 -0400
Message-ID: <46698358.2030407@de.ibm.com>
Date: Fri, 08 Jun 2007 18:27:04 +0200
From: Martin Peschke <mp3@de.ibm.com>
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH_Vor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen_Ge?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher_Sitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen_Registergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Bill Huey (hui)" <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, jbaron@redhat.com, rostedt@goodmis.org,
       linux-s390@vger.kernel.org
Subject: Re: [RFC] [Patch 4/4] lock contention tracking slimmed down
References: <1181165656.7133.23.camel@dix> <20070606230641.GA11592@elte.hu> <46674EA9.9090601@de.ibm.com> <20070607044017.GA3828@gnuppy.monkey.org> <4667ADDA.2070202@de.ibm.com> <20070607073021.GA21139@elte.hu>
In-Reply-To: <20070607073021.GA21139@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
 > Firstly, submit cleanup patches that _do not change the output_. If you
 > have any output changes, do it as a separate patch, ontop of the cleanup
 > patch. Mixing material changes and cleanups into a single patch is a
 > basic patch submission mistake that will only earn you NACKs.

Let's put this straight: it has not been my primary goal to clean it up.
I have posted an alternative implementation. One of the good things about the
alternative implementation is lines-of-savings through code sharing.

Don't hear me say my code is perfect. As anybody else here I am relying on
reviews and feedback in order to make it good enough.

I think there has been enough duplication to consider a component
that statistics data is handed over to.

Martin


