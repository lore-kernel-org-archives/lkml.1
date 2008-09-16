Return-Path: <linux-kernel-owner+w=401wt.eu-S1753074AbYIPJ17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbYIPJ17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 05:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYIPJ1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 05:27:51 -0400
Received: from smtp2.smiths.com ([192.208.34.51]:32882 "EHLO smtp2.smiths.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbYIPJ1u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 05:27:50 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Server process stalled during massive thread creation : scheduler problem ?
Date: Tue, 16 Sep 2008 03:27:48 -0600
Message-ID: <531F9EE7AD1E874595D59997FD3EAEED043D7947@COSSMGMBX05.EMAIL.CORP.TLD>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: RE: Server process stalled during massive thread creation : scheduler problem ?
Thread-Index: AckX3nwQgbdJBgy0S3ufPgzoEVmAdA==
From: "Cornelius, Martin (DWBI)" <Martin.Cornelius@smiths-heimann.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 Sep 2008 09:27:49.0484 (UTC) FILETIME=[7C72B2C0:01C917DE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Christopher Snook wrote:

> I would conclude that the application is severely broken, not the
server
> itself. The scheduler is trying to be fair.  Unless you're assigning 
> priorities, it has no way of knowing that those 1000 CPU hog processes
are
> less important than your netcat process.  Once those processes have
shown
> to be much longer-running than netcat, the kernel realizes that giving
> netcat priority is the the best approximation to ideal 
> shortest-time-to-completion-first scheduling, so netcat gets to run 
> whenever it's able.

> I think the scheduler is working correctly.  If you still see this
> behavior when you give your netcat process higher scheduler priority,
then
> we can talk about bugs.

Hi Chris, thanks for answering my question. I repeated the test, giving
the 'netcat' server a much higher priority than the load generators, and
indeed, the stalling disappeared.

 
************************************************
The information contained in, or attached to, this e-mail, may contain confidential information and is intended solely for the use of the individual or entity to whom they are addressed and may be subject to legal privilege.  If you have received this e-mail in error you should notify the sender immediately by reply e-mail, delete the message from your system and notify your system manager.  Please do not copy it for any purpose, or disclose its contents to any other person.  The views or opinions presented in this e-mail are solely those of the author and do not necessarily represent those of the company.  The recipient should check this e-mail and any attachments for the presence of viruses.  The company accepts no liability for any damage caused, directly or indirectly, by any virus transmitted in this email.
************************************************
