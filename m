Return-Path: <linux-kernel-owner+w=401wt.eu-S1753594AbZGVU5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbZGVU5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 16:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbZGVU5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 16:57:21 -0400
Received: from smtp-out.google.com ([216.239.45.13]:37591 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbZGVU5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 16:57:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Ldns60f3Sq/TjkgQ2FH89RRNecxCEdrValp9xRnVGiYrJChdMJbTZnYSiRjXQPLtR
	caQp/WDzz7F/AbqFMOnrg==
MIME-Version: 1.0
In-Reply-To: <20090721220017.60A219D3@kernel>
References: <20090721220017.60A219D3@kernel>
Date: Wed, 22 Jul 2009 13:57:17 -0700
Message-ID: <2f86c2480907221357j5a09fd9au890f815db3750187@mail.gmail.com>
Subject: Re: [RFCv2][PATCH] flexible array implementation
From: Benjamin Blum <bblum@google.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, menage@google.com,
       vda.linux@googlemail.com, mikew@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does the array automatically grow if you give it more elements than
you tell it it can have? How about a resize() function that can be
used to either grow or shrink the array?
