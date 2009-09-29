Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbZI2URu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbZI2URu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 16:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbZI2URu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 16:17:50 -0400
Received: from mail.perches.com ([173.55.12.10]:1428 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbZI2URt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 16:17:49 -0400
Subject: Re: [PATCH] cmpc_acpi: Added support for Classmate PC ACPI devices.
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       linux-kernel@vger.kernel.org, len.brown@intel.com, don@syst.com.br,
       linux-acpi@vger.kernel.org
In-Reply-To: <20090929130522.ecf4d5ec.akpm@linux-foundation.org>
References: <1254188280-29155-1-git-send-email-cascardo@holoscopio.com>
	 <20090929130522.ecf4d5ec.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Sep 2009 13:17:52 -0700
Message-Id: <1254255472.3797.12.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-29 at 13:05 -0700, Andrew Morton wrote:
> static acpi_status cmpc_start_accel(acpi_handle handle)
> {
> 	union acpi_object param[2];
> 	struct acpi_object_list input;
> 	acpi_status status;
> 
> 	param[0].type = ACPI_TYPE_INTEGER;
> 	param[0].integer.value = 0x3;
> 	param[1].type = ACPI_TYPE_INTEGER;
> 	input.count = 2;
> 	input.pointer = param;
> 	status = acpi_evaluate_object(handle, "ACMD", &input, NULL);
> 	return status;
> }
> 
> puts a smile on our faces.

Much better, but what appears to be incomplete initialization
of stack variables is also a bit offputting.

cheers, Joe


