Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828AbYAZRKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbYAZRKh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 12:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbYAZRK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 12:10:27 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:44153 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbYAZRK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 12:10:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=A9ppbU4IkVjqZzBXerbP2G7PlBf5AtxfqVRI9UwyEINfJYCVeYMNKP/Li6TjaBUNgLx/s4uzzQ9NcCV8Z5Lzn/K5BSoRlX6tFX0NShkQ3yPs0Z1vcHNW/hlg5vLE24B01zwBiMatqdV0/OEYZhlNPWNccWud79DjWDOfEs84i8I=
Message-ID: <2f11576a0801260910m762cceaau32a7fae3875824a5@mail.gmail.com>
Date: Sun, 27 Jan 2008 02:10:25 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Mel Gorman" <mel@csn.ul.ie>
Subject: Re: [PATCH 0/2] Relax restrictions on setting CONFIG_NUMA on x86
Cc: mingo@elte.hu, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       apw@shadowen.org, kosaki.motohiro@gmail.com
In-Reply-To: <2f11576a0801260610m29f4e7ecle9828d8bbaa462cd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080118153529.12646.5260.sendpatchset@skynet.skynet.ie>
	 <20080121093702.8FC2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080123105810.F295.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080123102332.GB21455@csn.ul.ie>
	 <2f11576a0801260610m29f4e7ecle9828d8bbaa462cd@mail.gmail.com>
X-Google-Sender-Auth: 52c16b51dc4b4909
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1. if sparce_mem on, build failture

after fix compile error, no panic and bad-page happened both highmem
off and 64G.
I guess discontigmem numa is premature yet ;-)
