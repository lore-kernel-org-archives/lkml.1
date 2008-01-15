Return-Path: <linux-kernel-owner+w=401wt.eu-S1756506AbYAOKhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbYAOKhd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 05:37:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbYAOKhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 05:37:25 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:39713 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbYAOKhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 05:37:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WpeQWK6l08iXpOmHAxynKaAO/g/ICZj8iCDrnzoECYMx3EtMEPjpk3ug6JAbPMCDwh0qqkaRyn6x4iJb5dq6LMS8VropyrfkXsHtVZ/Xg/raz0fGbWKdCblMhzX/kLm95aCB9LscUVxqQh29tXOXMPM6scJryHzMINoqJL/Kas4=
Subject: Re: [PATCH] [9/31] CPA: Add simple self test at boot
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, jbeulich@novell.com, mingo@elte.hu,
       tglx@linutronix.de
In-Reply-To: <20080114221641.5217614F83@wotan.suse.de>
References: <200801141116.534682000@suse.de>
	 <20080114221641.5217614F83@wotan.suse.de>
Content-Type: text/plain
Date: Tue, 15 Jan 2008 02:37:25 -0800
Message-Id: <1200393445.16794.35.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-01-14 at 23:16 +0100, Andi Kleen wrote:
> Since change_page_attr() is tricky code it is good to have some regression
> test code. This patch maps and unmaps some random pages in the direct mapping
> at boot and then dumps the state and does some simple sanity checks.
> 
> Add it with a CONFIG option.
> 
> Optional patch, but I find it useful.

Has it been decided if a new /test directory is going to be
created for this kind of smoketest?

Harvey

