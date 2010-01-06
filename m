Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009Ab0AFHOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab0AFHOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 02:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751679Ab0AFHOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 02:14:43 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58567 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab0AFHOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 02:14:43 -0500
Date: Wed, 6 Jan 2010 08:14:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Huang Ying <ying.huang@intel.com>
Cc: lenb@kernel.org, ak@linux.intel.com, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 5/5] ACPI, APEI, Document for APEI
Message-ID: <20100106071431.GB1494@ucw.cz>
References: <1261980744-4450-1-git-send-email-ying.huang@intel.com> <1261980744-4450-2-git-send-email-ying.huang@intel.com> <1261980744-4450-3-git-send-email-ying.huang@intel.com> <1261980744-4450-4-git-send-email-ying.huang@intel.com> <1261980744-4450-5-git-send-email-ying.huang@intel.com> <1261980744-4450-6-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261980744-4450-6-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-12-28 14:12:24, Huang Ying wrote:
> Add document for APEI, including kernel parameters and EINJ debug file
> sytem interface.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> ---
>  Documentation/acpi/apei/einj.txt    |   49 +++++++++++++++++++++++++++++++++++
>  Documentation/kernel-parameters.txt |    5 +++
>  2 files changed, 54 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/acpi/apei/einj.txt
> 
> diff --git a/Documentation/acpi/apei/einj.txt b/Documentation/acpi/apei/einj.txt
> new file mode 100644
> index 0000000..438ef33
> --- /dev/null
> +++ b/Documentation/acpi/apei/einj.txt
> @@ -0,0 +1,49 @@
> +			APEI Error INJection
> +			~~~~~~~~~~~~~~~~~~~~
> +
> +EINJ provides a hardware error injection mechanism, it is very useful
> +for debugging and testing of other APEI and RAS features.
> +
> +To use EINJ, make the following is enabled in your kernel
> +configuration:
> +
> +CONFIG_DEBUG_FS
> +CONFIG_ACPI_APEI
> +CONFIG_ACPI_APEI_EINJ
> +
> +The user interface of EINJ is in debug file system, under the
> +directory apei/einj. The following files are provided.
> +
> +- available_error_type
> +  Read this file will return the error injection capability of the
> +  platform, that is, which error types are supported. The error type
> +  definition is as follow, the left field is the error type value, the
> +  right field is error description.
> +
> +    0x00000001	Processor Correctable
> +    0x00000002	Processor Uncorrectable non-fatal
> +    0x00000004	Processor Uncorrectable fatal
> +    0x00000008  Memory Correctable
> +    0x00000010  Memory Uncorrectable non-fatal
> +    0x00000020  Memory Uncorrectable fatal
> +    0x00000040	PCI Express Correctable
> +    0x00000080	PCI Express Uncorrectable fatal
> +    0x00000100	PCI Express Uncorrectable non-fatal
> +    0x00000200	Platform Correctable
> +    0x00000400	Platform Uncorrectable non-fatal
> +    0x00000800	Platform Uncorrectable fatal
> +
> +  The format of file contents are as above, except there are only the
> +  available error type lines.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
