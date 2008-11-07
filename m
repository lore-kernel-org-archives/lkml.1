Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbYKGTi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbYKGTi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 14:38:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbYKGTip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 14:38:45 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:51922 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbYKGTio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 14:38:44 -0500
Date: Fri, 7 Nov 2008 11:38:31 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 1/5] adt7462: New hwmon driver
Message-ID: <20081107193831.GB8800@plum>
Reply-To: djwong@us.ibm.com
References: <20081107185621.13022.61885.stgit@elm3a70.beaverton.ibm.com> <20081107185626.13022.59407.stgit@elm3a70.beaverton.ibm.com> <1226084691.11596.42.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226084691.11596.42.camel@brick>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 11:04:51AM -0800, Harvey Harrison wrote:
> > +#define ROUND_DIV(x, divisor)  (((x) + ((divisor) / 2)) / (divisor))
> 
> DIV_ROUND_UP ?

Actually, on closer inspection, DIV_ROUND_UP always rounds up, so I'll
implement a ROUND_CLOSEST.

--D
