Return-Path: <linux-kernel-owner+w=401wt.eu-S1758064AbYDGMQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbYDGMQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 08:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754131AbYDGMQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 08:16:40 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:60470 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086AbYDGMQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 08:16:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=jA5OtSlOd4fJ+kF4FObovmT+WNs3kf/pkjAtk9DuH62xc25QlKGaTxGMe6CH1Mw73h7uyXIHEeMURYfYTsyMueixIDsSJysVutMH+GPmQCO0ZzbT8dfxTikK9VjC9W3uyPpgHAEtwedmtDIEFmPbcwPSVGzbOYeXKSLdAJ4pjvw=
Message-ID: <2f11576a0804070516r185bff87t449c315bd7787c7e@mail.gmail.com>
Date: Mon, 7 Apr 2008 21:16:39 +0900
From: "KOSAKI Motohiro" <m-kosaki@ceres.dti.ne.jp>
To: balbir@linux.vnet.ibm.com
Subject: Re: [-mm] Disable the memory controller by default
Cc: "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>,
       "Paul Menage" <menage@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, "Pavel Emelianov" <xemul@openvz.org>,
       hugh@veritas.com, "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47FA0D85.201@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080407115137.24124.59692.sendpatchset@localhost.localdomain>
	 <20080407120340.GB16647@one.firstfloor.org>
	 <47FA0D85.201@linux.vnet.ibm.com>
X-Google-Sender-Auth: aee355de66958f7b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  The boot control options apply to all controllers and we want to allow
>  controllers to decide whether they should be turned on or off. With sufficient
>  documentation support in Documentation/kernel-parameters.txt, don't you think we
>  can expect this to work as the user intended?

2 parameter is wrong?

       cgroup_disable= [KNL] Disable a particular controller
                       Format: {name of the controller(s) to disable}
       cgroup_enable= [KNL] Enable a particular controller
                       Format: {name of the controller(s) to enable}

e.g.
user specified cgroup_enable=mem.
if default value is disable, it mean turn to enable.
if default value is enable,  it is meaningless param.
