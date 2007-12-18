Return-Path: <linux-kernel-owner+w=401wt.eu-S1754447AbXLRVAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbXLRVAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 16:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbXLRVAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 16:00:36 -0500
Received: from hs-out-0708.google.com ([64.233.178.245]:18967 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753003AbXLRVAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 16:00:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZoRswgTsVcKgCQwWZ36eaYpDfsZbvhI1raC5AVT6jRAjF/chX6Xkvh9GP695XKw1Vi3shvE26i803Y24KICfEoxIBMQyPQtbl/aaTef07omMfcglPKwvdelYiBKZ6TTNvn3MUd4I75Z14jqF0fEqN8GUDblC4yat+E8nSPTOCNQ=
Message-ID: <5d6222a80712181300l707035e7mdb8a6e0d7a5ddca8@mail.gmail.com>
Date: Tue, 18 Dec 2007 19:00:33 -0200
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Frans Pop" <elendil@planet.nl>
Subject: Re: [PATCH] finish processor.h integration
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>, ak@suse.de,
       akpm@linux-foundation.org, anthony@codemonkey.ws, avi@qumranet.com,
       chrisw@sous-sol.org, ehabkost@redhat.com, hpa@zytor.com,
       jeremy@goop.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       roland@redhat.com, rostedt@goodmis.org, rusty@rustcorp.com.au,
       tglx@linutronix.de, virtualization@lists.linux-foundation.org,
       zach@vmware.com
In-Reply-To: <E1J4jSf-00024X-GN@faramir.fjphome.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1198008293639-git-send-email-gcosta@redhat.com>
	 <E1J4jSf-00024X-GN@faramir.fjphome.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 18, 2007 6:54 PM, Frans Pop <elendil@planet.nl> wrote:
> Glauber de Oliveira Costa wrote:
> > What's left in processor_32.h and processor_64.h cannot be cleanly
> > integrated. However, it's just a couple of definitions. They are moved
> > to processor.h around ifdefs, and the original files are deleted. Note
> > that there's much less headers included in the final version.
>
> Either I must be missing something or this patch was corrupted somehow.

neither.
Note the else in the middle. It's just a mistake in the comment.
Ingo, do you want me to send an update with it ?

-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
