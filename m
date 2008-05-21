Return-Path: <linux-kernel-owner+w=401wt.eu-S937480AbYEUUkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937480AbYEUUkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 16:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764337AbYEUUkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 16:40:19 -0400
Received: from saeurebad.de ([85.214.36.134]:47059 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755876AbYEUUkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 16:40:18 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: mark <markkicks@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: fork: Resource temporarily unavailable / cant start new threads
References: <82fa9e310805201126q45e869bdub74a947068fe612a@mail.gmail.com>
	<20080521132845.72db5748.randy.dunlap@oracle.com>
Date: Wed, 21 May 2008 22:39:52 +0200
In-Reply-To: <20080521132845.72db5748.randy.dunlap@oracle.com> (Randy Dunlap's
	message of "Wed, 21 May 2008 13:28:45 -0700")
Message-ID: <873aob4civ.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Randy Dunlap <randy.dunlap@oracle.com> writes:

> On Tue, 20 May 2008 11:26:47 -0700 mark wrote:
>> have only 505 processes running
>> ps aux | wc -l
>> 505

[ quoting deleted for clarification ]

>> max user processes              (-u) 1024

> The only place that fork() returns EAGAIN is for number of
> processes being >= its limit.  Does this user already have >= 1024
> processes?

	Hannes
