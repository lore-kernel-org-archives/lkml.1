Return-Path: <linux-kernel-owner+w=401wt.eu-S1757103AbYJMITd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103AbYJMITd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 04:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755513AbYJMITV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 04:19:21 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:34815 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756641AbYJMITU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 04:19:20 -0400
Subject: Re: [RFC][PATCH 1/2] Track in-kernel when we	expect
	checkpoint/restart to work
From: Greg Kurz <gkurz@fr.ibm.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>, Ingo Molnar <mingo@elte.hu>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <48EF8E77.8050000@nortel.com>
References: <20081009190405.13A253CB@kernel>
	 <1223626834.8787.8.camel@localhost.localdomain>
	 <48EF144D.1050906@fr.ibm.com> <20081010145934.GF11695@elte.hu>
	 <48EF7211.2000303@cs.columbia.edu>
	 <1223656489.10017.33.camel@localhost.localdomain>
	 <48EF8E77.8050000@nortel.com>
Content-Type: text/plain
Date: Mon, 13 Oct 2008 10:18:17 +0200
Message-Id: <1223885897.4404.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-10 at 11:18 -0600, Chris Friesen wrote:
> Greg Kurz wrote:
> 
> > This flag is weak... testing it gives absolutly no hint whether the
> > checkpoint may succeed or not. As it is designed now, a user can only be
> > aware that checkpoint is *forever* denied. I agree that it's only useful
> > as a "flexible CR todo list".
> 
> I don't think it's true that it gives "absolutly no hint".
> 
> If the flag is not set, then checkpoint will succeed, right?  Whereas if 

Wrong. Unless you test_and_checkpoint atomically, the flag doesn't help.

> the flag is set, then it's an indication that checkpoint could fail (but 
> may still succeed if whatever condition caused the flag to be set is no 
> longer true).
> 
> Chris
> 
-- 
Gregory Kurz                                     gkurz@fr.ibm.com
Software Engineer @ IBM/Meiosys                  http://www.ibm.com
Tel +33 (0)534 638 479                           Fax +33 (0)561 400 420

"Anarchy is about taking complete responsibility for yourself."
        Alan Moore.

