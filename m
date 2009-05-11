Return-Path: <linux-kernel-owner+w=401wt.eu-S1754034AbZEKGyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbZEKGyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 02:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbZEKGyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 02:54:25 -0400
Received: from science.horizon.com ([192.35.100.1]:45043 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751417AbZEKGyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 02:54:24 -0400
Date: 11 May 2009 02:54:24 -0400
Message-ID: <20090511065424.25138.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: johnstul@us.ibm.com, linux@horizon.com
Subject: Re: [RFC][PATCH] tsc_khz= boot option to avoid TSC calibration variance
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       ulrich.windl@rz.uni-regensburg.de, williams@redhat.com,
       zippel@linux-m68k.org
In-Reply-To: <1241809372.7297.3.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just as a data point, I have this patch running on two PPS-synced
NTP servers with apparent success.  After thinking through the sign
conventions carefully, (if NTP reports a that it is applying a positive
clock frequency adjustment, the TSC frequency should be reduced by that
amount), I now have the NTP frequency offset within a couple PPM of 0.

Thanks for the patch!
