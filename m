Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbXLEW7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbXLEW7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 17:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbXLEW7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 17:59:10 -0500
Received: from smtp-103-wednesday.noc.nerim.net ([62.4.17.103]:2773 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752146AbXLEW7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 17:59:09 -0500
Date: Wed, 5 Dec 2007 23:59:05 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Wagner Ferenc <wferi@niif.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: bonding sysfs output
Message-ID: <20071205235905.7e8ac1b1@hyperion.delvare>
In-Reply-To: <87lk8lflzf.fsf@szonett.ki.iif.hu>
References: <87tznafjeu.fsf@szonett.ki.iif.hu>
	<20071125205150.4e49915f.akpm@linux-foundation.org>
	<87lk8lflzf.fsf@szonett.ki.iif.hu>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wagner,

On Mon, 26 Nov 2007 09:29:40 +0100, Wagner Ferenc wrote:
> On the policy side: some files are not applicable to some types of
> bonds, and return a single linefeed in that case.  Except for one
> single case, which returns 'NA\n'.  The patch changes these cases into
> emtpy files.

IMHO a better approach would be to not create the files at all when
they make no sense for a given type of bond.

-- 
Jean Delvare
