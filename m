Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbZAWTgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbZAWTgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 14:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbZAWTgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 14:36:11 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60944 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981AbZAWTgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 14:36:10 -0500
Date: Fri, 23 Jan 2009 14:36:01 -0500
From: Dave Jones <davej@redhat.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: cat /proc/cpuinfo shows full throttle
Message-ID: <20090123193601.GB1295@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Justin P. Mattock" <justinmattock@gmail.com>,
	linux-kernel@vger.kernel.org
References: <49798D8B.5050503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49798D8B.5050503@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2009 at 01:27:39AM -0800, Justin P. Mattock wrote:

 > I'm confused here  when doing a cat /proc/cpuinfo
 > with an idle system, I see cpu MHz at 2167.000;
 > should be at 1000.00 (when settled down);
 >  ..
 > 
 > In any case the system is idle and quiet.
 > it just says full throttle when it should say
 > nice and quiet.
 
is acpi-cpufreq loaded ? and cpufreq-ondemand ?
(Also make sure the relevant sysfs knobs are set to use ondemand)

If no: Make them so!
If yes: boot with cpufreq.debug=7 and send the dmesg
 to cpufreq@vger.kernel.org

Thanks,

	Dave

-- 
http://www.codemonkey.org.uk
