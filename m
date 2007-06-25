Return-Path: <linux-kernel-owner+w=401wt.eu-S1752185AbXFYHTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbXFYHTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 03:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbXFYHTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 03:19:37 -0400
Received: from smtp-out.google.com ([216.239.33.17]:1730 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbXFYHTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 03:19:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=VTTR4DQtKlp8xoAx9DaaMCN5dfiH7N9a11X6l0OY861N5A14atUThWSbD3Uhk8bAn
	jhrfjXVutQLfdDB/Pj/fg==
Message-ID: <6599ad830706250019h117ff575h156cf112f5778e43@mail.gmail.com>
Date: Mon, 25 Jun 2007 00:19:25 -0700
From: "Paul Menage" <menage@google.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [patch -rss] Make RSS accounting display more user friendly
Cc: "Pavel Emelianov" <xemul@openvz.org>, "Andrew Morton" <akpm@osdl.org>,
       "Linux Containers" <containers@lists.osdl.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <661de9470706222048g638a06dboc0b2e85975a9ba70@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070620154655.13844.42876.sendpatchset@balbir-laptop>
	 <6599ad830706211217l65d76d4ehb42f9165bcf45dd@mail.gmail.com>
	 <467B2F4F.2030101@openvz.org>
	 <6599ad830706220839h2a556c76he11b78c2c4cdb86e@mail.gmail.com>
	 <661de9470706222048g638a06dboc0b2e85975a9ba70@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/22/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
> The problem with input in bytes is that the user will have to ensure
> that the input is
> a  multiple of page size, which implies that she would need to use the
> calculator every time.
>

Having input in bytes seems pretty natural to me. Why not just have
the RSS controller round the input to the nearest page (or whatever
granularity of memory the controller is able to limit at)?

Paul
