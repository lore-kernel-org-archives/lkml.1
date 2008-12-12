Return-Path: <linux-kernel-owner+w=401wt.eu-S1755657AbYLLV77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbYLLV77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 16:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbYLLV7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 16:59:43 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:64081 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbYLLV7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 16:59:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=qFs+S2HkO7M1pL5gmTiAt5goJGL63DoZw/dEIjTcpJTAcQM3S1kTmMz5WluggJerpA
         wIZ2EvPGze/kX1Ty7hzvGrU6H7N+9JKx2tjx5mE4IXm2Tfw5EODMzpxqOqL+eRiiRt4g
         2Pz/zy/G3b9d4Fyq80LDwLbc3TYvlwQjxG6Q0=
Message-ID: <86802c440812121359qc39ed4esf3817b2b65c7cfb8@mail.gmail.com>
Date: Fri, 12 Dec 2008 13:59:41 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Dimitri Sivanich" <sivanich@sgi.com>
Subject: Re: Intel x86_64 llc_shared_map/cpu_llc_id anomolies
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081212214256.GA20559@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081212214256.GA20559@sgi.com>
X-Google-Sender-Auth: 4c408f7d32ae7c65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 1:42 PM, Dimitri Sivanich <sivanich@sgi.com> wrote:
> I'm seeing some behavior on a multiblade Intel x86_64 that does not
> appear to be correct.

can you post your boot log?

can you make sure phys_proc_id-->cpu_core_id-->thread_id ===> apic id
is consistent to your SRAT table/MADT etc?

YH
