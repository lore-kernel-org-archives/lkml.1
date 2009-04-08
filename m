Return-Path: <linux-kernel-owner+w=401wt.eu-S1759283AbZDHFLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283AbZDHFLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 01:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZDHFL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 01:11:27 -0400
Received: from mga05.intel.com ([192.55.52.89]:40508 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752543AbZDHFL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 01:11:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,342,1235980800"; 
   d="scan'208";a="679749732"
Message-ID: <49DC31EA.8050208@linux.intel.com>
Date: Tue, 07 Apr 2009 22:11:06 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       wireless <linux-wireless@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Regression in 2.6.30-rc1 since commit acae0515 - wireless broken
References: <49DC2DF5.3010603@lwfinger.net>
In-Reply-To: <49DC2DF5.3010603@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger wrote:
> The most recent pulls of the Linux-2.6 git tree has broken wireless. The problem
> was bisected with commit acae05156551fd7528fbb616271e672789388e3c, entitled
> "module: create a request_module_nowait()", indicated as the faulty change. This
> is seen with driver b43 on my system, and 2 reports for driver iwlagn:
> http://marc.info/?l=linux-wireless&m=123916157630571&w=2 and
> http://marc.info/?l=linux-wireless&m=123913015021457&w=2.
> 
> For b43, the logged error messages are:

rusty... I still suspect your "int to bool" conversion stuff ;-)
the rest is pretty close to syntactic noop
