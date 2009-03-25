Return-Path: <linux-kernel-owner+w=401wt.eu-S1756534AbZCYB1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbZCYB1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 21:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbZCYB1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 21:27:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:64882 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbZCYB1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 21:27:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=qsI6dzr9KOBylxd2UdRHNDaym1dek0eCppIsn4fjTcy0FmvMTb5BCEEZywrHteXVxE
         SDP8phOKMX1WnzWWUrIcMhrL8zG/IN7EX5w++Sd71ArgxfNbpHK9S+F1W9lgo2OweIXk
         RpkieTf0mLwVwZsQs48JT8tzfWfDsSaHzQ3mY=
Message-ID: <49C9885F.2090604@gmail.com>
Date: Tue, 24 Mar 2009 19:26:55 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, shaohua.li@intel.com, arjan@infradead.org,
       James.Bottomley@HansenPartnership.com
Subject: sd-async-shutdown.patch [was: 2.6.30 -mm merge plans]
References: <20090323224615.cd29edfd.akpm@linux-foundation.org>
In-Reply-To: <20090323224615.cd29edfd.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>     sd-async-shutdown.patch
> 
>  Merge

This one seems questionable to me. Is this going to allow the machine to 
power off before the disk shutdown is complete? That's definitely 
something we don't want (for cache flushing and head unload reasons).
