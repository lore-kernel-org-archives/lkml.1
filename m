Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbYBXDMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbYBXDMn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 22:12:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYBXDMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 22:12:36 -0500
Received: from qmta08.westchester.pa.mail.comcast.net ([76.96.62.80]:44090
	"EHLO QMTA08.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751008AbYBXDMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 22:12:35 -0500
X-Authority-Analysis: v=1.0 c=1 a=d2AfEDShp-gA:10 a=V11zJMkrBZ6MfeP-V_gA:9
 a=dmoIiHOOxeDtBW5onrjMaKwPchIA:4 a=si9q_4b84H0A:10 a=WuK_CZDBSqoA:10
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
From: Nicholas Miell <nmiell@comcast.net>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, sandmann@redhat.com, tglx@tglx.de, hpa@zytor.com
In-Reply-To: <47C0DB2E.5000404@cs.helsinki.fi>
References: <20080219123756.6261c13c@laptopd505.fenrus.org>
	 <20080223001130.d8922136.akpm@linux-foundation.org>
	 <84144f020802230351o24b11282vbb1cecf518d91825@mail.gmail.com>
	 <20080223104611.a3430285.akpm@linux-foundation.org>
	 <47C0DB2E.5000404@cs.helsinki.fi>
Content-Type: text/plain
Date: Sat, 23 Feb 2008 19:12:27 -0800
Message-Id: <1203822747.2439.1.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8.0.njm.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-02-24 at 04:49 +0200, Pekka Enberg wrote:
> Hi Andrew,
> 
> Andrew Morton wrote:
> > I didn't need to write a new kernel module to enable that
> > thirteen-character shell script, and I don't believe one needs to write a
> > new kernel module to put a nice easy-to-use GUI around oprofile either.
> > 
> > This is one of those i-cant-believe-im-having-this-discussion discussions.
> 
> Sysprof tracks the full stack frame so it can provide meaningful call 
> tree (who called what) which is invaluable for spotting hot _paths_. I 
> don't see how oprofile can do that as it tracks instruction pointers only.
> 
> 			Pekka

You could try passing the --callgraph option to opcontrol.

-- 
Nicholas Miell <nmiell@comcast.net>

