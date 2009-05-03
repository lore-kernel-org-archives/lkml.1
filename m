Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbZECURW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbZECURW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 16:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbZECURN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 16:17:13 -0400
Received: from senator.holtmann.net ([87.106.208.187]:47851 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbZECURM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 16:17:12 -0400
Subject: Re: [BUG] 2.6.30-rc4 hid bluetooth not working
From: Marcel Holtmann <marcel@holtmann.org>
To: Marc Pignat <Marc.Pignat@hevs.ch>
Cc: justinmattock@gmail.com, hidave.darkstar@gmail.com,
       ext-roger.quadros@nokia.com, jkosina@suse.cz,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <49FDCC85020000BF000290ED@mailgw2.hevs.ch>
References: <49FDCC85020000BF000290ED@mailgw2.hevs.ch>
Content-Type: text/plain
Date: Sun, 03 May 2009 13:17:01 -0700
Message-Id: <1241381821.2785.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

you really need to fix your mailer. You keep breaking the threading all
the time and that is clearly your fault.

> > thanks for testing.
> 
> > Marc, Roger, can you test this and confirm that it works for you and
> > doesn't have any other side effects. Then I prepare it work upstream
> > inclusion.
> 
> Tested and working!

great. So I queue this up for 2.6.30 inclusion.

> Exercise left for 2.6.31: use the system wide wq ;)

Actually no, the private workqueue is used on purpose. No need to bother
keventd for a regular task.

Regards

Marcel


